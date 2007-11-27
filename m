From: akpm@linux-foundation.org
Subject: - doc-add-uio-document-to-docbook-compilation-target.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:34:26 -0800
Message-ID: <200711272034.lARKYQUq029116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756360AbXK0UhJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:37:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takeuchi_satoru@jp.fujitsu.com, greg@kroah.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     doc: add uio document to docbook compilation target
has been removed from the -mm tree.  Its filename was
     doc-add-uio-document-to-docbook-compilation-target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: doc: add uio document to docbook compilation target
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

`make *docs' doesn't generate "The Userspace I/O HOWTO", the user space
I/O document written in DocBook.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/Makefile~doc-add-uio-document-to-docbook-compilation-target Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~doc-add-uio-document-to-docbook-compilation-target
+++ a/Documentation/DocBook/Makefile
@@ -11,7 +11,7 @@ DOCBOOKS := wanbook.xml z8530book.xml mc
 	    procfs-guide.xml writing_usb_driver.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml s390-drivers.xml scsi.xml
+	    genericirq.xml s390-drivers.xml scsi.xml uio-howto.xml
 
 ###
 # The build process is as follows (targets):
_

Patches currently in -mm which might be from takeuchi_satoru@jp.fujitsu.com are
