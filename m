From: akpm@linux-foundation.org
Subject: + kexec-update-url-in-maintainers-file.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:55:55 -0700
Message-ID: <200710172155.l9HLttwu010234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbXJQV4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au


The patch titled
     Kexec: Update URL in MAINTAINERS file
has been added to the -mm tree.  Its filename is
     kexec-update-url-in-maintainers-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
kexec-update-url-in-maintainers-file.patch
