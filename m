From: akpm@linux-foundation.org
Subject: - kexec-update-url-in-maintainers-file.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:26 -0700
Message-ID: <200710190340.l9J3eQ1n012709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965654AbXJSDlF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:41:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, mm-commits@vger.kernel.org


The patch titled
     Kexec: Update URL in MAINTAINERS file
has been removed from the -mm tree.  Its filename was
     kexec-update-url-in-maintainers-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kexec: Update URL in MAINTAINERS file
From: "Signed-off-by@vergenet.net":Simon Horman <horms@verge.net.au>

I'm not sure that the new URL satifies the requirement of status/info, but
it does at least as good a job as the old URL, and contains current
releases of kexec-tools, rather than somewhat ancient versions.

Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~kexec-update-url-in-maintainers-file MAINTAINERS
--- a/MAINTAINERS~kexec-update-url-in-maintainers-file
+++ a/MAINTAINERS
@@ -2234,7 +2234,7 @@ S:	Supported
 KEXEC
 P:	Eric Biederman
 M:	ebiederm@xmission.com
-W:	http://www.xmission.com/~ebiederm/files/kexec/
+W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
 L:	linux-kernel@vger.kernel.org
 L:	kexec@lists.infradead.org
 S:	Maintained
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
