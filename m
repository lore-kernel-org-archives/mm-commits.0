From: akpm@linux-foundation.org
Subject: + maintainers-update-ibm-serveraid-raid-info.patch added to -mm
 tree
Date: Mon, 10 Mar 2014 13:21:17 -0700
Message-ID: <531e1ebd.1YJWDrqE6dtddr48%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaCJUVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pebolle@tiscali.nl, jdelvare@suse.de, dhjeffery@gmail.com, James.Bottomley@HansenPartnership.com, michael.opdenacker@free-electrons.com

Subject: + maintainers-update-ibm-serveraid-raid-info.patch added to -mm tree
To: michael.opdenacker@free-electrons.com,James.Bottomley@HansenPartnership.com,dhjeffery@gmail.com,jdelvare@suse.de,pebolle@tiscali.nl
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:21:17 -0700


The patch titled
     Subject: MAINTAINERS: update IBM ServeRAID RAID info
has been added to the -mm tree.  Its filename is
     maintainers-update-ibm-serveraid-raid-info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-ibm-serveraid-raid-info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-ibm-serveraid-raid-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: MAINTAINERS: update IBM ServeRAID RAID info

- Invalid maintainer e-mail address:
  Mail server reply:
  Recipient address rejected: User unknown in virtual alias table
- Remove no longer working webpage URL
- Remove obsolete "Person" field
- Move status to "Orphan"
- Add Dave Jeffery and Jack Hammer to the CREDITS file

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Cc: David Jeffery <dhjeffery@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    7 +++++++
 MAINTAINERS |    5 +----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN CREDITS~maintainers-update-ibm-serveraid-raid-info CREDITS
--- a/CREDITS~maintainers-update-ibm-serveraid-raid-info
+++ a/CREDITS
@@ -1370,6 +1370,9 @@ S: 17 rue Danton
 S: F - 94270 Le Kremlin-Bicêtre
 S: France
 
+N: Jack Hammer
+D: IBM ServeRAID RAID (ips) driver maintenance
+
 N: Greg Hankins
 E: gregh@cc.gatech.edu
 D: fixed keyboard driver to separate LED and locking status
@@ -1680,6 +1683,10 @@ S: Reading
 S: RG6 2NU
 S: United Kingdom
 
+N: Dave Jeffery
+E: dhjeffery@gmail.com
+D: SCSI hacks and IBM ServeRAID RAID driver maintenance
+
 N: Jakub Jelinek
 E: jakub@redhat.com
 W: http://sunsite.mff.cuni.cz/~jj
diff -puN MAINTAINERS~maintainers-update-ibm-serveraid-raid-info MAINTAINERS
--- a/MAINTAINERS~maintainers-update-ibm-serveraid-raid-info
+++ a/MAINTAINERS
@@ -4296,10 +4296,7 @@ F:	drivers/scsi/ibmvscsi/
 X:	drivers/scsi/ibmvscsi/ibmvstgt.c
 
 IBM ServeRAID RAID DRIVER
-P:	Jack Hammer
-M:	Dave Jeffery <ipslinux@adaptec.com>
-W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
-S:	Supported
+S:	Orphan
 F:	drivers/scsi/ips.*
 
 ICH LPC AND GPIO DRIVER
_

Patches currently in -mm which might be from michael.opdenacker@free-electrons.com are

maintainers-blackfin-add-git-repository.patch
score-remove-unused-cpu_score7-kconfig-parameter.patch
maintainers-update-ibm-serveraid-raid-info.patch
linux-next.patch

