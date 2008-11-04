From: akpm@linux-foundation.org
Subject: + docs-document-how-to-write-varargs-in-kernel-doc.patch added to -mm tree
Date: Mon, 03 Nov 2008 16:39:26 -0800
Message-ID: <200811040039.mA40dQeb030568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772AbYKDAjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 19:39:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, rusty@rustcorp.com.au


The patch titled
     docs: document how to write @varargs in kernel-doc
has been added to the -mm tree.  Its filename is
     docs-document-how-to-write-varargs-in-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docs: document how to write @varargs in kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add documentation on how to use kernel-doc for function parameters
that are "..." (varargs).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~docs-document-how-to-write-varargs-in-kernel-doc Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~docs-document-how-to-write-varargs-in-kernel-doc
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -71,6 +71,11 @@ The @argument descriptions must begin on
 this opening short function description line, with no intervening
 empty comment lines.
 
+If a function parameter is "..." (varargs), it should be listed in
+kernel-doc notation as:
+ * @...: description
+
+
 Example kernel-doc data structure comment.
 
 /**
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
fusion-remove-excess-kernel-doc-notation.patch
profile-likely-unlikely-macros.patch

