From: akpm@linux-foundation.org
Subject: [merged] kexec-fix-a-typo-in-comment.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:04 -0800
Message-ID: <54e4eb48.KoVu4P3JL4zuBA+7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbbBRTnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix a typo in comment
has been removed from the -mm tree.  Its filename was
     kexec-fix-a-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-fat-remove-unnecessary-defintion.patch
fs-fat-remove-unnecessary-includes.patch

