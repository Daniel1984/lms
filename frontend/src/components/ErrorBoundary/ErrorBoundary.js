import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import Center from '../Common/Center/Center'
import InfoBox from '../Common/InfoBox/InfoBox'

class ErrorBoundary extends PureComponent {
  constructor(props) {
    super(props)

    this.state = {
      hasError: false,
    }
  }

  componentDidCatch(error, info) {
    console.log(error, info)
    if (process.env.ERROR_LOGGING === 'on') {
      // decide what error tracking tool to use, usually Sentry does good job
      // but there's a ton of other tools to consider too
    } else {
      this.setState({ hasError: true })
    }
  }

  render() {
    const { hasError } = this.state
    const { children } = this.props

    if (hasError) {
      return (
        <Center>
          <InfoBox type="alert">
            Sorry, something went wrong. Please try again later
          </InfoBox>
        </Center>
      )
    }

    return children
  }
}

ErrorBoundary.propTypes = {
  children: PropTypes.node.isRequired,
}

export default ErrorBoundary
