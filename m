From: akpm@linux-foundation.org
Subject: + ide-add-seagate-stt20000a-to-dma-blacklist.patch added to -mm tree
Date: Mon, 21 May 2007 15:31:29 -0700
Message-ID: <200705212231.l4LMVTdR021578@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997AbXEUWeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 18:34:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com


The patch titled
     ide: add Seagate STT20000A to DMA blacklist
has been added to the -mm tree.  Its filename is
     ide-add-seagate-stt20000a-to-dma-blacklist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ide-add-seagate-stt20000a-to-dma-blacklist.patch
