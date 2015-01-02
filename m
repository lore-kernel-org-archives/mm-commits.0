From: akpm@linux-foundation.org
Subject: + kexec-fix-a-typo-in-comment.patch added to -mm tree
Date: Fri, 02 Jan 2015 15:42:52 -0800
Message-ID: <54a72cfc.ihdi3LQ9SDrYe9HB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbABXmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 18:42:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix a typo in comment
has been added to the -mm tree.  Its filename is
     kexec-fix-a-typo-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-fix-a-typo-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-fix-a-typo-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: kexec: fix a typo in comment

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec.c~kexec-fix-a-typo-in-comment kernel/kexec.c
--- a/kernel/kexec.c~kexec-fix-a-typo-in-comment
+++ a/kernel/kexec.c
@@ -444,7 +444,7 @@ arch_kexec_apply_relocations(const Elf_E
 }
 
 /*
- * Free up memory used by kernel, initrd, and comand line. This is temporary
+ * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have
  * been loaded into separate segments and have been copied elsewhere.
  */
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

kexec-fix-a-typo-in-comment.patch

