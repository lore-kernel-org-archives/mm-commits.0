From: akpm@linux-foundation.org
Subject: + hfsplus-fix-typo-in-printk.patch added to -mm tree
Date: Tue, 29 Apr 2008 13:44:36 -0700
Message-ID: <200804292044.m3TKiaZB008871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756785AbYD2Upd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 16:45:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, zippel@linux-m68k.org


The patch titled
     hfsplus: fix typo in printk
has been added to the -mm tree.  Its filename is
     hfsplus-fix-typo-in-printk.patch

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
Subject: hfsplus: fix typo in printk
From: Dave Jones <davej@redhat.com>

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/super.c~hfsplus-fix-typo-in-printk fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-fix-typo-in-printk
+++ a/fs/hfsplus/super.c
@@ -357,7 +357,7 @@ static int hfsplus_fill_super(struct sup
 		printk(KERN_WARNING "hfs: Filesystem is marked locked, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
 	} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
-		printk(KERN_WARNING "hfs: write access to a jounaled filesystem is not supported, "
+		printk(KERN_WARNING "hfs: write access to a journaled filesystem is not supported, "
 		       "use the force option at your own risk, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
 	}
_

Patches currently in -mm which might be from davej@redhat.com are

hfsplus-fix-typo-in-printk.patch
git-cpufreq.patch

