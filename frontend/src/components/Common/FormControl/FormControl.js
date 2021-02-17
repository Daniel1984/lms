import React from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import Label from '../Label/Label'
import css from './FormControl.module.scss'

const FormControl = (props) => {
  const {
    children,
    label,
    vertical,
    htmlFor,
    renderHelper,
    style,
    labelClassName,
    labelsClassName,
  } = props

  return (
    <div
      className={cn({
        [css.root]: true,
        [css.vertical]: vertical,
        [style]: !!style
      })}
    >
      <div className={cn(css.labels, labelsClassName)}>
        {(!!label && !!htmlFor) && (
          <>
            <Label
              htmlFor={htmlFor}
              vertical={vertical}
              className={cn(css.label, labelClassName)}
            >
              {label}
            </Label>
            {renderHelper ? renderHelper() : null}
          </>
        )}
      </div>
      <div className={css.input}>
        {children}
      </div>
    </div>
  )
}

FormControl.propTypes = {
  children: PropTypes.node.isRequired,
  label: PropTypes.oneOfType([PropTypes.string, PropTypes.node]),
  vertical: PropTypes.bool,
  htmlFor: PropTypes.string,
  renderHelper: PropTypes.func,
  style: PropTypes.string,
  labelClassName: PropTypes.string,
  labelsClassName: PropTypes.string
}

FormControl.defaultProps = {
  label: '',
  style: '',
  htmlFor: '',
  labelClassName: '',
  labelsClassName: '',
  renderHelper: null,
  vertical: true
}

export default FormControl
