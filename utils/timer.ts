import { log } from './loggerUtils'

export default function countFromOneUntil (lastNumberInclusive: number): void {
  for (let i = 1; i <= lastNumberInclusive; i++) {
    log.info(i)
  }
}
