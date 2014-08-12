From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-two-ancient-eata-sections.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:58 -0700
Message-ID: <53ea6e06.4QCgTzuktZ5P/k30%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:55743 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbaHLTl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:59 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1920365oah.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove two ancient EATA sections
has been removed from the -mm tree.  Its filename was
     maintainers-remove-two-ancient-eata-sections.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove two ancient EATA sections

These haven't had a single ack by the listed maintainer in all git history
and the email addresses don't work.

An EATA entry for Michael Neuffer is already in CREDITS.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-two-ancient-eata-sections MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-two-ancient-eata-sections
+++ a/MAINTAINERS
@@ -3239,26 +3239,12 @@ T:	git git://linuxtv.org/anttip/media_tr
 S:	Maintained
 F:	drivers/media/tuners/e4000*
 
-EATA-DMA SCSI DRIVER
-M:	Michael Neuffer <mike@i-Connect.Net>
-L:	linux-eata@i-connect.net
-L:	linux-scsi@vger.kernel.org
-S:	Maintained
-F:	drivers/scsi/eata*
-
 EATA ISA/EISA/PCI SCSI DRIVER
 M:	Dario Ballabio <ballabio_dario@emc.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata.c
 
-EATA-PIO SCSI DRIVER
-M:	Michael Neuffer <mike@i-Connect.Net>
-L:	linux-eata@i-connect.net
-L:	linux-scsi@vger.kernel.org
-S:	Maintained
-F:	drivers/scsi/eata_pio.*
