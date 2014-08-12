From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-ibm-serveraid-raid-info.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:00 -0700
Message-ID: <53ea6e08.vujquh2DdbIj/Hu0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:32881 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbaHLTmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:01 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so1920805oac.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.opdenacker@free-electrons.com, James.Bottomley@HansenPartnership.com, dhjeffery@gmail.com, jdelvare@suse.de, jg1.han@samsung.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update IBM ServeRAID RAID info
has been removed from the -mm tree.  Its filename was
     maintainers-update-ibm-serveraid-raid-info.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: MAINTAINERS: update IBM ServeRAID RAID info

- Invalid maintainer e-mail address:
  Mail server reply:
  Recipient address rejected: User unknown in virtual alias table
- Remove no longer working webpage URL
- Remove obsolete "Person" field
- Move status to "Orphan"
- Add Dave Jeffery and Jack Hammer to the CREDITS file

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.co=
m>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Cc: David Jeffery <dhjeffery@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    7 +++++++
 MAINTAINERS |    5 +----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN CREDITS~maintainers-update-ibm-serveraid-raid-info CREDITS
--- a/CREDITS~maintainers-update-ibm-serveraid-raid-info
+++ a/CREDITS
@@ -1381,6 +1381,9 @@ S: 17 rue Danton
 S: F - 94270 Le Kremlin-Bic=C3=AAtre
 S: France
=20
+N: Jack Hammer
+D: IBM ServeRAID RAID (ips) driver maintenance
+
 N: Greg Hankins
 E: gregh@cc.gatech.edu
 D: fixed keyboard driver to separate LED and locking status
@@ -1691,6 +1694,10 @@ S: Reading
 S: RG6 2NU
 S: United Kingdom
=20
+N: Dave Jeffery
+E: dhjeffery@gmail.com
+D: SCSI hacks and IBM ServeRAID RAID driver maintenance
+
 N: Jakub Jelinek
 E: jakub@redhat.com
 W: http://sunsite.mff.cuni.cz/~jj
diff -puN MAINTAINERS~maintainers-update-ibm-serveraid-raid-info MAINTA=
INERS
--- a/MAINTAINERS~maintainers-update-ibm-serveraid-raid-info
+++ a/MAINTAINERS
@@ -4495,10 +4495,7 @@ S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvfc*
=20
 IBM ServeRAID RAID DRIVER
-P:	Jack Hammer
-M:	Dave Jeffery <ipslinux@adaptec.com>
-W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
-S:	Supported
+S:	Orphan
 F:	drivers/scsi/ips.*
=20
 ICH LPC AND GPIO DRIVER
_

Patches currently in -mm which might be from michael.opdenacker@free-el=
ectrons.com are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
