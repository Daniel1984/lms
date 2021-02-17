import React from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import { FiAlertTriangle } from 'react-icons/fi'
import css from './FormError.module.scss'

const FormError = ({ children, style }) => (
  <div
    className={cn({
      [css.root]: true,
      [style]: !!style
    })}
  >
    <FiAlertTriangle className={css.warningIcon} />
    {children}
  </div>
)

FormError.propTypes = {
  children: PropTypes.node.isRequired,
  style: PropTypes.string,
}

FormError.defaultProps = {
  style: '',
}

export default FormError
