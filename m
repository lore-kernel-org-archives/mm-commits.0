From: akpm@linux-foundation.org
Subject: + remove-andrew-mortons-http-wwwzipcomau-akpm.patch added to -mm tree
Date: Fri, 10 Oct 2008 14:27:36 -0700
Message-ID: <200810102127.m9ALRaHp004237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760085AbYJJV1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 17:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: francois.cami@free.fr


The patch titled
     Remove Andrew Morton's http://www.zip.com.au/~akpm/
has been added to the -mm tree.  Its filename is
     remove-andrew-mortons-http-wwwzipcomau-akpm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove Andrew Morton's http://www.zip.com.au/~akpm/
From: FD Cami <francois.cami@free.fr>

Remove Andrew Morton's http://www.zip.com.au/~akpm/ urls, update to new
ones when necessary, delete references otherwise.

There are still instances of that living in:
Documentation/zh_CN/HOWTO
Documentation/zh_CN/SubmittingPatches
Documentation/ko_KR/HOWTO
Documentation/ja_JP/SubmittingPatches

Signed-off-by: Francois Cami <francois.cami@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/HOWTO                 |    4 ++--
 Documentation/SubmittingPatches     |    4 ++--
 Documentation/filesystems/ext3.txt  |    3 +--
 Documentation/networking/vortex.txt |    5 -----
 4 files changed, 5 insertions(+), 11 deletions(-)

diff -puN Documentation/HOWTO~remove-andrew-mortons-http-wwwzipcomau-akpm Documentation/HOWTO
--- a/Documentation/HOWTO~remove-andrew-mortons-http-wwwzipcomau-akpm
+++ a/Documentation/HOWTO
@@ -112,7 +112,7 @@ required reading:
 
     Other excellent descriptions of how to create patches properly are:
 	"The Perfect Patch"
-		http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+		http://userweb.kernel.org/~akpm/stuff/tpp.txt
 	"Linux kernel patch submission format"
 		http://linux.yyz.us/patch-format.html
 
@@ -620,7 +620,7 @@ all time.  It should describe the patch 
 For more details on what this should all look like, please see the
 ChangeLog section of the document:
   "The Perfect Patch"
-      http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
+      http://userweb.kernel.org/~akpm/stuff/tpp.txt
 
 
 
diff -puN Documentation/SubmittingPatches~remove-andrew-mortons-http-wwwzipcomau-akpm Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~remove-andrew-mortons-http-wwwzipcomau-akpm
+++ a/Documentation/SubmittingPatches
@@ -77,7 +77,7 @@ Quilt:
 http://savannah.nongnu.org/projects/quilt
 
 Andrew Morton's patch scripts:
-http://www.zip.com.au/~akpm/linux/patches/
+http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
 Instead of these scripts, quilt is the recommended patch management
 tool (see above).
 
@@ -653,7 +653,7 @@ SECTION 3 - REFERENCES
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt>
+  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
diff -puN Documentation/filesystems/ext3.txt~remove-andrew-mortons-http-wwwzipcomau-akpm Documentation/filesystems/ext3.txt
--- a/Documentation/filesystems/ext3.txt~remove-andrew-mortons-http-wwwzipcomau-akpm
+++ a/Documentation/filesystems/ext3.txt
@@ -193,6 +193,5 @@ kernel source:	<file:fs/ext3/>
 programs: 	http://e2fsprogs.sourceforge.net/
 		http://ext2resize.sourceforge.net
 
-useful links:	http://www.zip.com.au/~akpm/linux/ext3/ext3-usage.html
-		http://www-106.ibm.com/developerworks/linux/library/l-fs7/
+useful links:	http://www-106.ibm.com/developerworks/linux/library/l-fs7/
 		http://www-106.ibm.com/developerworks/linux/library/l-fs8/
diff -puN Documentation/networking/vortex.txt~remove-andrew-mortons-http-wwwzipcomau-akpm Documentation/networking/vortex.txt
--- a/Documentation/networking/vortex.txt~remove-andrew-mortons-http-wwwzipcomau-akpm
+++ a/Documentation/networking/vortex.txt
@@ -305,11 +305,6 @@ Donald's wake-on-LAN page:
 
 	ftp://ftp.3com.com/pub/nic/3c90x/3c90xx2.exe
 
-Driver updates and a detailed changelog for the modifications which
-were made for the 2.3/2,4 series kernel is available at
-
-     http://www.zip.com.au/~akpm/linux/#3c59x-bc
