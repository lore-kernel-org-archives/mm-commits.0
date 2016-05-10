From: akpm@linux-foundation.org
Subject: + maintainers-add-co-maintainer-for-scripts-gdb.patch added to
 -mm tree
Date: Tue, 10 May 2016 12:34:48 -0700
Message-ID: <573237d8.6geku5HROWIVO1fr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbcEJTet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran@ksquared.org.uk, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add co-maintainer for scripts/gdb
has been added to the -mm tree.  Its filename is
     maintainers-add-co-maintainer-for-scripts-gdb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-co-maintainer-for-scripts-gdb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-co-maintainer-for-scripts-gdb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kieran Bingham <kieran@bingham.xyz>
Subject: MAINTAINERS: add co-maintainer for scripts/gdb

Add myself as a co-maintainer for scripts/gdb supporting Jan Kizka

Link: http://lkml.kernel.org/r/fb5d34ce563f33d2f324f26f592b24ded30032ee.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-co-maintainer-for-scripts-gdb MAINTAINERS
--- a/MAINTAINERS~maintainers-add-co-maintainer-for-scripts-gdb
+++ a/MAINTAINERS
@@ -4773,6 +4773,7 @@ F:	drivers/scsi/gdt*
 
 GDB KERNEL DEBUGGING HELPER SCRIPTS
 M:	Jan Kiszka <jan.kiszka@siemens.com>
+M:	Kieran Bingham <kieran@bingham.xyz>
 S:	Supported
 F:	scripts/gdb/
 
_

Patches currently in -mm which might be from kieran@bingham.xyz are

scripts-gdb-decode-bytestream-on-dmesg-for-python3.patch
maintainers-add-co-maintainer-for-scripts-gdb.patch

