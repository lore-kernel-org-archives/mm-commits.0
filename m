From: akpm@linux-foundation.org
Subject: + documentation-update-mount-option-in-filesystem-vfattxt.patch added to -mm tree
Date: Wed, 01 Aug 2012 14:46:01 -0700
Message-ID: <20120801214602.1020D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:41494 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610Ab2HAVqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 17:46:05 -0400
Received: by lagr15 with SMTP id r15so345858lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 14:46:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: Documentation: update mount option in filesystem/vfat.txt
has been added to the -mm tree.  Its filename is
     documentation-update-mount-option-in-filesystem-vfattxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Documentation: update mount option in filesystem/vfat.txt

Update two mount options(discard, nfs) in vfat.txt.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN Documentation/filesystems/vfat.txt~documentation-update-mount-option-in-filesystem-vfattxt Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~documentation-update-mount-option-in-filesystem-vfattxt
+++ a/Documentation/filesystems/vfat.txt
@@ -137,6 +137,17 @@ errors=panic|continue|remount-ro
 		 without doing anything or remount the partition in
 		 read-only mode (default behavior).
 
+discard       -- If set, issues discard/TRIM commands to the block
+		 device when blocks are freed. This is useful for SSD devices
+		 and sparse/thinly-provisoned LUNs.
+
+nfs           -- This option maintains an index (cache) of directory
+		 inodes by i_logstart which is used by the nfs-related code to
+		 improve look-ups.
+
+		 Enable this only if you want to export the FAT filesystem
+		 over NFS
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch
documentation-update-mount-option-in-filesystem-vfattxt.patch

