# Progressive Delivery Canary App

![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![Fastify](https://img.shields.io/badge/Fastify-000000?style=for-the-badge&logo=fastify&logoColor=white)
![Vitest](https://img.shields.io/badge/Vitest-6E9F18?style=for-the-badge&logo=vitest&logoColor=white)

A small Fastify application designed to demonstrate **progressive delivery and canary deployments** on Kubernetes.

The application provides several endpoints that intentionally generate different response statuses, latency, and failure behaviour. This makes it useful for testing traffic splitting, monitoring, alerting, and comparing stable and canary deployments.

## Endpoints

| Endpoint    |        Status | Behaviour                            |
| ----------- | ------------: | ------------------------------------ |
| `/`         |         `200` | Returns the current deployment track |
| `/500`      |         `500` | Always returns HTTP 500              |
| `/404`      |         `404` | Always returns HTTP 404              |
| `/error`    |         `500` | Throws an error                      |
| `/flaky`    | `200` / `503` | Randomly fails ~10% of requests      |
| `/slow`     |         `200` | Adds a random 300–1000 ms delay      |
| `/redirect` |         `302` | Redirects to `/`                     |

### Deployment Track

The `/` endpoint uses the `DEPLOYMENT_TRACK` environment variable to identify which deployment handled the request.

For example:

```text
Hello world stable
```

or:

```text
Hello world canary
```

If `DEPLOYMENT_TRACK` is not set, the application returns:

```text
Hello world unknown
```

This makes it easy to identify whether a request was handled by the stable or canary deployment.

## Running Locally

Install dependencies:

```bash
yarn install
```

Start the application:

```bash
yarn dev
```

The application will be available at:

```text
http://localhost:3000
```

Set the deployment track with:

```bash
DEPLOYMENT_TRACK=stable yarn dev
```

Test the application:

```bash
curl http://localhost:3000/
```

## Testing

The project uses [Vitest](https://vitest.dev/) for testing.

Run the test suite with:

```bash
yarn test
```

The tests cover:

- Successful requests
- HTTP 404 responses
- HTTP 500 responses
- Application errors
- Flaky requests
- Delayed requests
- Redirects

Tests are also automatically executed through GitHub Actions on pushes and pull requests.

## Traffic Simulation

The `scripts/` directory contains scripts for generating different types of application traffic:

```text
scripts/
├── all.sh
├── error-traffic.sh
├── load-test.sh
├── normal-payload.sh
└── user-simulation.sh
```

### Normal Traffic

```bash
BASE_URL=http://localhost:3000 ./scripts/normal-payload.sh
```

### Error Traffic

```bash
BASE_URL=http://localhost:3000 ./scripts/error-traffic.sh
```

### Load Test

```bash
BASE_URL=http://localhost:3000 ./scripts/load-test.sh
```

### User Simulation

```bash
BASE_URL=http://localhost:3000 ./scripts/user-simulation.sh
```

### Full Demo

Run all traffic scenarios:

```bash
BASE_URL=http://localhost:3000 ./scripts/all.sh
```

These scripts can generate:

- Normal application traffic
- High request volumes
- HTTP errors
- Random failures
- Slow requests
- Redirects
- Simulated users

They can also be pointed at the deployed application:

```bash
BASE_URL=https://your-domain.example ./scripts/all.sh
```

## OpenTelemetry

The application includes OpenTelemetry instrumentation through `src/otel.ts`.

Application telemetry can be sent to an OpenTelemetry Collector and then visualised through the observability stack used by the Kubernetes deployment.

This allows application requests, errors, and latency to be observed during progressive delivery experiments.

## Progressive Delivery

The application is designed to run as two deployments:

```text
                 ┌──────────────┐
                 │   Gateway    │
                 └──────┬───────┘
                        │
              ┌─────────┴─────────┐
              │                   │
        Stable deployment   Canary deployment
              │                   │
        DEPLOYMENT_TRACK     DEPLOYMENT_TRACK
          = stable              = canary
```

Traffic can then be progressively shifted between the two deployments.

For example:

```text
Stable   90%
Canary   10%
```

Then:

```text
Stable   50%
Canary   50%
```

And eventually:

```text
Stable    0%
Canary  100%
```

The different application behaviours make it possible to observe the impact of each deployment through latency, errors, and request volume.

## Project Structure

```text
.
├── package.json
├── readme.md
├── scripts/
│   ├── all.sh
│   ├── error-traffic.sh
│   ├── load-test.sh
│   ├── normal-payload.sh
│   └── user-simulation.sh
├── src/
│   ├── app.ts
│   ├── index.ts
│   ├── otel.ts
│   ├── routes/
│   │   └── controller.ts
│   └── tests/
│       └── controller.test.ts
├── tsconfig.json
└── yarn.lock
```

## Related Infrastructure

The Kubernetes infrastructure and observability stack are maintained separately in:

**[progressive-delivery-canary-k8s](https://github.com/rubencosta13/progressive-delivery-canary-k8s)** (PUBLIC SOON)

It contains the infrastructure used to deploy and observe this application, including:

- Kubernetes
- Kind
- Argo CD
- Traefik
- Prometheus
- Grafana
- Jaeger
- OpenTelemetry Collector
