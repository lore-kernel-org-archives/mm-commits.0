From: akpm@linux-foundation.org
Subject: + maintainers-fix-tape-driver-file-mappings.patch added to -mm
 tree
Date: Thu, 30 May 2013 15:28:50 -0700
Message-ID: <51a7d2a2.JrNY4eB3KIKPaTPR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759981Ab3E3W2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, osst@riede.org, Kai.Makisara@kolumbus.fi, JBottomley@parallels.com, jdelvare@suse.de

Subject: + maintainers-fix-tape-driver-file-mappings.patch added to -mm tree
To: jdelvare@suse.de,JBottomley@parallels.com,Kai.Makisara@kolumbus.fi,osst@riede.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:28:50 -0700


The patch titled
     Subject: MAINTAINERS: fix tape driver file mappings
has been added to the -mm tree.  Its filename is
     maintainers-fix-tape-driver-file-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: MAINTAINERS: fix tape driver file mappings

The masks for the st and osst tape drivers in MAINTAINERS are too
broad and include unrelated files. Make the file list accurate so that
maintainers of these drivers aren't bothered with unrelated work.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Willem Riede <osst@riede.org>
Cc: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-tape-driver-file-mappings MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-tape-driver-file-mappings
+++ a/MAINTAINERS
@@ -5936,8 +5936,10 @@ M:	Willem Riede <osst@riede.org>
 L:	osst-users@lists.sourceforge.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-F:	drivers/scsi/osst*
-F:	drivers/scsi/st*
+F:	Documentation/scsi/osst.txt
+F:	drivers/scsi/osst.*
+F:	drivers/scsi/osst_*.h
+F:	drivers/scsi/st.h
 
 OPENCORES I2C BUS DRIVER
 M:	Peter Korsgaard <jacmet@sunsite.dk>
@@ -7077,7 +7079,8 @@ M:	Kai MÃ¤kisara <Kai.Makisara@kolumbus.
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/st.txt
-F:	drivers/scsi/st*
+F:	drivers/scsi/st.*
+F:	drivers/scsi/st_*.h
 
 SCTP PROTOCOL
 M:	Vlad Yasevich <vyasevich@gmail.com>
_

Patches currently in -mm which might be from jdelvare@suse.de are

maintainers-fix-tape-driver-file-mappings.patch
idr-print-a-stack-dump-after-ida_remove-warning.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch

