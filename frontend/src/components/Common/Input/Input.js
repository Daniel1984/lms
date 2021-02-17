import React from 'react'
import PropTypes from 'prop-types'
import { Field } from 'formik'
import cn from 'classnames'
import css from './Input.module.scss'

const Input = (props) => {
  const {
    type,
    error,
    style,
    rootClassName,
    innerRef,
    ...rest
  } = props

  return (
    <div className={cn(css.root, rootClassName)}>
      <Field
        innerRef={innerRef}
        type={type}
        className={cn({
          [css.input]: true,
          [css.withError]: !!error,
          [style]: !!style
        })}
        {...rest}
      />
      {(error && typeof error === 'string') && (
        <span className={css.error}>{error}</span>
      )}
    </div>
  )
}

Input.propTypes = {
  style: PropTypes.string,
  rootClassName: PropTypes.string,
  innerRef: PropTypes.shape({}),
  type: PropTypes.string.isRequired,
  error: PropTypes.oneOfType([PropTypes.bool, PropTypes.string]),
}

Input.defaultProps = {
  style: null,
  rootClassName: null,
  error: null,
  innerRef: null,
}

export default Input
