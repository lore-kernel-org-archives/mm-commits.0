From: akpm@linux-foundation.org
Subject: +
 documentation-filesystems-vfattxt-fix-directory-entry-example.patch added
 to -mm tree
Date: Mon, 23 Sep 2013 15:18:00 -0700
Message-ID: <5240be18.2L5uAh5Rxd8bz61L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3IWWSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 18:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, luiorpe1@upv.es

Subject: + documentation-filesystems-vfattxt-fix-directory-entry-example.patch added to -mm tree
To: luiorpe1@upv.es,hirofumi@mail.parknet.co.jp
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 15:18:00 -0700


The patch titled
     Subject: Documentation/filesystems/vfat.txt: fix directory entry example
has been added to the -mm tree.  Its filename is
     documentation-filesystems-vfattxt-fix-directory-entry-example.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-filesystems-vfattxt-fix-directory-entry-example.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-filesystems-vfattxt-fix-directory-entry-example.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Ortega Perez de Villar <luiorpe1@upv.es>
Subject: Documentation/filesystems/vfat.txt: fix directory entry example

Slots can store up to 13 characters for the file name but one of the
examples has one character too many.

Signed-off-by: Luis Ortega Perez de Villar <luiorpe1@upv.es>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/filesystems/vfat.txt~documentation-filesystems-vfattxt-fix-directory-entry-example Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~documentation-filesystems-vfattxt-fix-directory-entry-example
+++ a/Documentation/filesystems/vfat.txt
@@ -307,7 +307,7 @@ the following:
 
                 <proceeding files...>
                 <slot #3, id = 0x43, characters = "h is long">
-                <slot #2, id = 0x02, characters = "xtension which">
+                <slot #2, id = 0x02, characters = "xtension whic">
                 <slot #1, id = 0x01, characters = "My Big File.E">
                 <directory entry, name = "MYBIGFIL.EXT">
 
_

Patches currently in -mm which might be from luiorpe1@upv.es are

documentation-filesystems-vfattxt-fix-directory-entry-example.patch

