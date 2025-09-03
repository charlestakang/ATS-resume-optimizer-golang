import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'ResumeSync Pro',
  description: 'ATS Resume Optimizer',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}