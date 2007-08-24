From: akpm@linux-foundation.org
Subject: - tpmdd-maintainers.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:13 -0700
Message-ID: <200708242055.l7OKtDPh013945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756579AbXHXUzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shpedoikal@gmail.com, kjhall@us.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpmdd maintainers
has been removed from the -mm tree.  Its filename was
     tpmdd-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tpmdd maintainers
From: "Kent Yoder" <shpedoikal@gmail.com>

Fix up the maintainers info in the tpm drivers.  Kylene will be out for
some time, so copying the sourceforge list is the best way to get some
attention.

Cc: Marcel Selhorst <tpm@selhorst.net>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                  |    2 +-
 drivers/char/tpm/tpm.c       |    2 +-
 drivers/char/tpm/tpm.h       |    2 +-
 drivers/char/tpm/tpm_atmel.c |    2 +-
 drivers/char/tpm/tpm_atmel.h |    2 +-
 drivers/char/tpm/tpm_bios.c  |    2 ++
 drivers/char/tpm/tpm_nsc.c   |    2 +-
 drivers/char/tpm/tpm_tis.c   |    2 ++
 8 files changed, 10 insertions(+), 6 deletions(-)

diff -puN MAINTAINERS~tpmdd-maintainers MAINTAINERS
--- a/MAINTAINERS~tpmdd-maintainers
+++ a/MAINTAINERS
@@ -3458,7 +3458,7 @@ S:	Maintained
 
 TPM DEVICE DRIVER
 P:	Kylene Hall
-M:	kjhall@us.ibm.com
+M:	tpmdd-devel@lists.sourceforge.net
 W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
diff -puN drivers/char/tpm/tpm.c~tpmdd-maintainers drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpmdd-maintainers
+++ a/drivers/char/tpm/tpm.c
@@ -7,7 +7,7 @@
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org	 
diff -puN drivers/char/tpm/tpm.h~tpmdd-maintainers drivers/char/tpm/tpm.h
--- a/drivers/char/tpm/tpm.h~tpmdd-maintainers
+++ a/drivers/char/tpm/tpm.h
@@ -7,7 +7,7 @@
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org	 
diff -puN drivers/char/tpm/tpm_atmel.c~tpmdd-maintainers drivers/char/tpm/tpm_atmel.c
--- a/drivers/char/tpm/tpm_atmel.c~tpmdd-maintainers
+++ a/drivers/char/tpm/tpm_atmel.c
@@ -7,7 +7,7 @@
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org	 
diff -puN drivers/char/tpm/tpm_atmel.h~tpmdd-maintainers drivers/char/tpm/tpm_atmel.h
--- a/drivers/char/tpm/tpm_atmel.h~tpmdd-maintainers
+++ a/drivers/char/tpm/tpm_atmel.h
@@ -4,7 +4,7 @@
  * Authors:
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org
diff -puN drivers/char/tpm/tpm_bios.c~tpmdd-maintainers drivers/char/tpm/tpm_bios.c
--- a/drivers/char/tpm/tpm_bios.c~tpmdd-maintainers
+++ a/drivers/char/tpm/tpm_bios.c
@@ -7,6 +7,8 @@
  *	Reiner Sailer <sailer@watson.ibm.com>
  *	Kylene Hall <kjhall@us.ibm.com>
  *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
  * Access to the eventlog extended by the TCG BIOS of PC platform
  *
  * This program is free software; you can redistribute it and/or
diff -puN drivers/char/tpm/tpm_nsc.c~tpmdd-maintainers drivers/char/tpm/tpm_nsc.c
--- a/drivers/char/tpm/tpm_nsc.c~tpmdd-maintainers
+++ a/drivers/char/tpm/tpm_nsc.c
@@ -7,7 +7,7 @@
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
- * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org	 
diff -puN drivers/char/tpm/tpm_tis.c~tpmdd-maintainers drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpmdd-maintainers
+++ a/drivers/char/tpm/tpm_tis.c
@@ -5,6 +5,8 @@
  * Leendert van Doorn <leendert@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
  * Device driver for TCG/TCPA TPM (trusted platform module).
  * Specifications at www.trustedcomputinggroup.org
  *
_

Patches currently in -mm which might be from shpedoikal@gmail.com are

origin.patch
