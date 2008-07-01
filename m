From: akpm@linux-foundation.org
Subject: + security-filesystem-capabilities-no-longer-experimental.patch added to -mm tree
Date: Tue, 01 Jul 2008 15:06:13 -0700
Message-ID: <200807012206.m61M6DKF017025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755827AbYGAWN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 18:13:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: morgan@kernel.org, serue@us.ibm.com


The patch titled
     security: filesystem capabilities no longer experimental
has been added to the -mm tree.  Its filename is
     security-filesystem-capabilities-no-longer-experimental.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security: filesystem capabilities no longer experimental
From: Andrew G. Morgan <morgan@kernel.org>

Filesystem capabilities have come of age.  Remove the experimental tag for
configuring filesystem capabilities.

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/Kconfig~security-filesystem-capabilities-no-longer-experimental security/Kconfig
--- a/security/Kconfig~security-filesystem-capabilities-no-longer-experimental
+++ a/security/Kconfig
@@ -82,8 +82,8 @@ config SECURITY_CAPABILITIES
 	  If you are unsure how to answer this question, answer Y.
 
 config SECURITY_FILE_CAPABILITIES
-	bool "File POSIX Capabilities (EXPERIMENTAL)"
-	depends on (SECURITY=n || SECURITY_CAPABILITIES!=n) && EXPERIMENTAL
+	bool "File POSIX Capabilities"
+	depends on SECURITY=n || SECURITY_CAPABILITIES!=n
 	default n
 	help
 	  This enables filesystem capabilities, allowing you to give
_

Patches currently in -mm which might be from morgan@kernel.org are

security-filesystem-capabilities-fix-fragile-setuid-fixup-code.patch
security-filesystem-capabilities-fix-fragile-setuid-fixup-code-checkpatch-fixes.patch
security-filesystem-capabilities-fix-cap_setpcap-handling.patch
security-filesystem-capabilities-fix-cap_setpcap-handling-fix.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-filesystem-capabilities-refactor-kernel-code.patch
security-filesystem-capabilities-no-longer-experimental.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

