From: akpm@linux-foundation.org
Subject: - security-filesystem-capabilities-no-longer-experimental.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:55 -0700
Message-ID: <200807242324.m6ONOtEn010823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbYGXXZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security: filesystem capabilities no longer experimental
has been removed from the -mm tree.  Its filename was
     security-filesystem-capabilities-no-longer-experimental.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 security/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN security/Kconfig~security-filesystem-capabilities-no-longer-experimental security/Kconfig
--- a/security/Kconfig~security-filesystem-capabilities-no-longer-experimental
+++ a/security/Kconfig
@@ -74,8 +74,7 @@ config SECURITY_NETWORK_XFRM
 	  If you are unsure how to answer this question, answer N.
 
 config SECURITY_FILE_CAPABILITIES
-	bool "File POSIX Capabilities (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "File POSIX Capabilities"
 	default n
 	help
 	  This enables filesystem capabilities, allowing you to give
_

Patches currently in -mm which might be from morgan@kernel.org are

origin.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

