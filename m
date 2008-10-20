From: akpm@linux-foundation.org
Subject: - kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:05 -0700
Message-ID: <200810202037.m9KKb5Bo011533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345AbYJTUqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kdump: update elfcorehdr documentation to reflect supported architectures
has been removed from the -mm tree.  Its filename was
     kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: update elfcorehdr documentation to reflect supported architectures
From: Simon Horman <horms@verge.net.au>

IA64, PPC and SH also support the elfcorehdr command line.

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures
+++ a/Documentation/kernel-parameters.txt
@@ -690,7 +690,7 @@ and is between 256 and 4096 characters. 
 			See Documentation/block/as-iosched.txt and
 			Documentation/block/deadline-iosched.txt for details.
 
-	elfcorehdr=	[X86-32, X86_64]
+	elfcorehdr=	[IA64,PPC,SH,X86-32,X86_64]
 			Specifies physical address of start of kernel core
 			image elf header. Generally kexec loader will
 			pass this option to capture kernel.
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch

