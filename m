From: akpm@linux-foundation.org
Subject: + potential-parse-error-drivers-i2c-busses-i2c-pmcmspc.patch added to -mm tree
Date: Mon, 16 Jul 2007 15:05:15 -0700
Message-ID: <200707162205.l6GM5IKW006714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758083AbXGPWFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 18:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: padator@wanadoo.fr, khali@linux-fr.org


The patch titled
     parse error, drivers/i2c/busses/i2c-pmcmsp.c
has been added to the -mm tree.  Its filename is
     potential-parse-error-drivers-i2c-busses-i2c-pmcmspc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: parse error, drivers/i2c/busses/i2c-pmcmsp.c
From: Yoann Padioleau <padator@wanadoo.fr>

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-pmcmsp.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-pmcmsp.c~potential-parse-error-drivers-i2c-busses-i2c-pmcmspc drivers/i2c/busses/i2c-pmcmsp.c
--- a/drivers/i2c/busses/i2c-pmcmsp.c~potential-parse-error-drivers-i2c-busses-i2c-pmcmspc
+++ a/drivers/i2c/busses/i2c-pmcmsp.c
@@ -630,7 +630,7 @@ static struct i2c_adapter pmcmsptwi_adap
 static struct platform_driver pmcmsptwi_driver = {
 	.probe  = pmcmsptwi_probe,
 	.remove	= __devexit_p(pmcmsptwi_remove),
-	.driver {
+	.driver = {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 	},
_

Patches currently in -mm which might be from padator@wanadoo.fr are

origin.patch
potential-parse-error-drivers-i2c-busses-i2c-pmcmspc.patch
git-alsa.patch
av7110-fix-typo.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
