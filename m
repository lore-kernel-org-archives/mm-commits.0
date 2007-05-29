From: akpm@linux-foundation.org
Subject: - ide-add-seagate-stt20000a-to-dma-blacklist.patch removed from -mm tree
Date: Tue, 29 May 2007 11:54:28 -0700
Message-ID: <200705291854.l4TIsROt008526@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760510AbXE2Sy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ide: add Seagate STT20000A to DMA blacklist
has been removed from the -mm tree.  Its filename was
     ide-add-seagate-stt20000a-to-dma-blacklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: add Seagate STT20000A to DMA blacklist
From: Dave Jones <davej@redhat.com>

http://bugzilla.kernel.org/show_bug.cgi?id=1044 has been open for _four_
years with a patch available.  Here's a rediffed version of the same.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-dma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/ide/ide-dma.c~ide-add-seagate-stt20000a-to-dma-blacklist drivers/ide/ide-dma.c
--- a/drivers/ide/ide-dma.c~ide-add-seagate-stt20000a-to-dma-blacklist
+++ a/drivers/ide/ide-dma.c
@@ -127,7 +127,8 @@ static const struct drive_list_entry dri
 	{ "SAMSUNG CD-ROM SC",	"ALL"		},
 	{ "SanDisk SDP3B-64"	,	"ALL"		},
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	"ALL"		},
-	{ "_NEC DV5800A",               "ALL"           },  
+	{ "_NEC DV5800A",               "ALL"           },
+	{ "Seagate STT20000A",          "ALL"           },
 	{ NULL			,	NULL		}
 
 };
_

Patches currently in -mm which might be from davej@redhat.com are

git-cpufreq.patch
git-scsi-rc-fixes.patch
fix-up-codingstyle-in-isofs.patch
