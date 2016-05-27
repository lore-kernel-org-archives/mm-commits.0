From: akpm@linux-foundation.org
Subject: [patch 10/19] MAINTAINERS: add kexec_core.c and kexec_file.c
Date: Fri, 27 May 2016 14:27:24 -0700
Message-ID: <5748bbbc.d2g/2Zk0b7HY43/p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbcE0V1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mnghuan@gmail.com

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
