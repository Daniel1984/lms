import React from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import css from './Button.module.scss'

const Button = ({
  children,
  style,
  type,
  kind,
  ...rest
}) => (
  <button
    type={type}
    className={cn({
      [css.root]: true,
      [css[kind]]: true,
      [style]: !!style,
    })}
    {...rest}
  >
    {children}
  </button>
)

Button.propTypes = {
  kind: PropTypes.oneOf(['default', 'success', 'danger', 'brand']),
  type: PropTypes.string,
  style: PropTypes.string,
  children: PropTypes.node.isRequired,
}

Button.defaultProps = {
  kind: 'default',
  type: 'button',
  style: '',
}

export default Button
