# Observability Fundamentals

This folder gathers core concepts you should align on before diving into specific tools or pipelines.

- **SLIs (Service Level Indicators)**: Concrete, queryable measures of service behavior (e.g., availability, latency, error rate, freshness, saturation). They must be well-defined, cheap to compute, and mapped to user journeys. Common dimensions:
  - **Availability**: Share of requests that succeed (typically 2xx/3xx) and avoid timeouts at the edge.
  - **Latency**: Time to serve a request; use percentiles (p50/p95/p99) rather than averages.
  - **Error rate**: Proportion of failed requests (HTTP 5xx/4xx where relevant, exceptions, or business-level failures).
  - **Freshness**: How up-to-date data is relative to a source-of-truth (e.g., replication or ingestion lag).
  - **Saturation**: How “full” a resource is (CPU, memory, queue length, thread pool, DB connections), indicating headroom before degradation.
- **SLOs (Service Level Objectives)**: Targets for SLIs over a rolling window (e.g., 99.9% success over 30 days). Set them with user impact in mind, and keep error budgets to balance reliability and velocity.
- **Cardinality management**: Control label/tag explosion in metrics and logs; cap high-cardinality dimensions (user IDs, request IDs), prefer bounded vocabularies, and enforce limits at ingestion to keep cost and performance predictable. Tips:
  - Avoid unbounded labels (user ID, session ID, raw URL params); hash or drop them unless absolutely needed.
  - Use controlled vocabularies for status codes, regions, components, feature flags to keep series count stable.
  - Enforce limits at emit time (whitelist labels) and at ingest time (cardinality guards) to prevent runaway cost and slow queries.
- **Telemetry design**: Decide what to measure and how to emit it across logs, metrics, and traces. Aim for consistent naming, shared IDs for correlation, sampling strategies for traces, and structured events that make questions answerable without ad-hoc parsing.
