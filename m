From: akpm@linux-foundation.org
Subject: + irda-fix-printk-format.patch added to -mm tree
Date: Tue, 26 Jun 2007 15:39:35 -0700
Message-ID: <200706262239.l5QMdZcd003869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbXFZWjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 18:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, samuel@sortiz.org


The patch titled
     IRDA: fix printk format
has been added to the -mm tree.  Its filename is
     irda-fix-printk-format.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IRDA: fix printk format
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:
drivers/net/irda/irport.c:512: warning: format '%d' expects type 'int', but argument 5 has type 'long int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/irport.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/irda/irport.c~irda-fix-printk-format drivers/net/irda/irport.c
--- a/drivers/net/irda/irport.c~irda-fix-printk-format
+++ a/drivers/net/irda/irport.c
@@ -509,7 +509,7 @@ static void irport_timeout(struct net_de
 	IRDA_DEBUG(0, "%s(), iir=%02x, lsr=%02x, iobase=%#x\n", 
 		   __FUNCTION__, iir, lsr, iobase);
 
-	IRDA_DEBUG(0, "%s(), transmitting=%d, remain=%d, done=%d\n", 
+	IRDA_DEBUG(0, "%s(), transmitting=%d, remain=%d, done=%ld\n",
 		   __FUNCTION__, self->transmitting, self->tx_buff.len,
 		   self->tx_buff.data - self->tx_buff.head);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

eventfd-clean-compile-when-config_eventfd=n.patch
mtrr-cyrix-fix-sections.patch
ioatdma-fix-section-mismatches.patch
alsa-fix-ice1712-section-mismatch.patch
alsa-use-__devexit_p.patch
git-acpi.patch
alsa-fix-section-mismatch.patch
alsa-more-section-mismatches.patch
alsa-portman2x4-section-mismatch.patch
fix-gregkh-driver-nozomi.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
ubi-one-less-bug-usage.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
irda-fix-printk-format.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
