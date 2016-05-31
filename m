From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-kexec_corec-and-kexec_filec.patch
 removed from -mm tree
Date: Tue, 31 May 2016 10:50:26 -0700
Message-ID: <574dcee2.kp+EFQt7bBoPp09T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbcEaRu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 13:50:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mnghuan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add kexec_core.c and kexec_file.c
has been removed from the -mm tree.  Its filename was
     maintainers-add-kexec_corec-and-kexec_filec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minfei Huang <mnghuan@gmail.com>
Subject: MAINTAINERS: add kexec_core.c and kexec_file.c

In the below commits kexec.c was split to kexec.c, kexec_file.c and
kexec_core.c.

commit a43cac0d9dc2 ("kexec: split kexec_file syscall code to kexec_file.c")
commit 2965faa5e03d ("kexec: split kexec_load syscall from kexec core code")

Both kexec_file.c and kexec_core.c still belong to the kexec component. 
In order to get correct mail lists by using the script get_maintainer.pl,
add these files to MAINTAINERS.

Link: http://lkml.kernel.org/r/1464189735-59113-1-git-send-email-mnghuan@gmail.com
Signed-off-by: Minfei Huang <mnghuan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-add-kexec_corec-and-kexec_filec MAINTAINERS
--- a/MAINTAINERS~maintainers-add-kexec_corec-and-kexec_filec
+++ a/MAINTAINERS
@@ -6559,7 +6559,7 @@ L:	kexec@lists.infradead.org
 S:	Maintained
 F:	include/linux/kexec.h
 F:	include/uapi/linux/kexec.h
-F:	kernel/kexec.c
+F:	kernel/kexec*
 
 KEYS/KEYRINGS:
 M:	David Howells <dhowells@redhat.com>
_

Patches currently in -mm which might be from mnghuan@gmail.com are

kexec-return-error-number-directly.patch

