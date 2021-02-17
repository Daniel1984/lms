import React from 'react'
import cn from 'classnames'
import PropTypes from 'prop-types'
import css from './Label.module.scss'

const Label = (props) => {
  const {
    children,
    htmlFor,
    vertical,
    style,
    disabled,
  } = props

  const title = children && Array.from(children)
    .filter((child) => typeof child === 'string')
    .join('')

  return (
    <label
      htmlFor={htmlFor}
      title={title}
      className={cn({
        [css.root]: true,
        [style]: !!style,
        [css.vertical]: vertical,
        [css.disabled]: disabled
      })}
    >
      {children}
    </label>
  )
}

Label.propTypes = {
  children: PropTypes.node.isRequired,
  htmlFor: PropTypes.string,
  style: PropTypes.string,
  vertical: PropTypes.bool,
  disabled: PropTypes.bool,
}

Label.defaultProps = {
  htmlFor: '',
  style: '',
  vertical: true,
  disabled: false,
}

export default Label
