import React from 'react'
import PropTypes from 'prop-types'
import st from './Spinner.module.scss'

const Spinner = ({ message }) => (
  <div className={st.root}>
    <div className={st.spinner} />
    {message && (
      <div className={st.message}>
        {message}
      </div>
    )}
  </div>
)

Spinner.propTypes = {
  message: PropTypes.string,
}

Spinner.defaultProps = {
  message: '',
}

export default Spinner
