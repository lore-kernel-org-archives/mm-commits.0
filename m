From: akpm@linux-foundation.org
Subject: + kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch added to -mm tree
Date: Tue, 05 Aug 2008 02:59:08 -0700
Message-ID: <200808050959.m759x8KK028892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230AbYHEKAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 06:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, vgoyal@redhat.com


The patch titled
     kdump: update elfcorehdr documentation to reflect supported architectures
has been added to the -mm tree.  Its filename is
     kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch

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
@@ -743,7 +743,7 @@ and is between 256 and 4096 characters. 
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
linux-next.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch
kdump-use-is_kdump_kernel-in-sba_init.patch
kdump-add-is_vmcore_usable-and-vmcore_unusable.patch
kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch
kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch

