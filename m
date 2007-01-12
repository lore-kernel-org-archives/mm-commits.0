From: akpm@osdl.org
Subject: + kdump-documentation-update-for-2620-kexec-tools-update.patch added to -mm tree
Date: Fri, 12 Jan 2007 14:49:38 -0800
Message-ID: <200701122249.l0CMncfF031395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161147AbXALWtq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:49:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, vgoyal@in.ibm.com


The patch titled
     Kdump documentation update: kexec-tools update
has been added to the -mm tree.  Its filename is
     kdump-documentation-update-for-2620-kexec-tools-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kdump documentation update: kexec-tools update
From: Horms <horms@verge.net.au>

Mohan Kumar suggested making kexec-tools-testing.tar.gz a link to the
latest version.  I have done this and this patch updates the documentation
accordingly.

Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kdump/kdump.txt |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff -puN Documentation/kdump/kdump.txt~kdump-documentation-update-for-2620-kexec-tools-update Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kdump-documentation-update-for-2620-kexec-tools-update
+++ a/Documentation/kdump/kdump.txt
@@ -61,7 +61,12 @@ Install kexec-tools
 
 2) Download the kexec-tools user-space package from the following URL:
 
-http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools-testing-20061214.tar.gz
+http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools-testing.tar.gz
+
+This is a symlink to the latest version, which at the time of writing is
+20061214, the only release of kexec-tools-testing so far. As other versions
+are made released, the older onese will remain available at
+http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
 
 Note: Latest kexec-tools-testing git tree is available at
 
@@ -71,11 +76,11 @@ http://www.kernel.org/git/?p=linux/kerne
 
 3) Unpack the tarball with the tar command, as follows:
 
-   tar xvpzf kexec-tools-testing-20061214.tar.gz
+   tar xvpzf kexec-tools-testing.tar.gz
 
-4) Change to the kexec-tools-1.101 directory, as follows:
+4) Change to the kexec-tools directory, as follows:
 
-   cd kexec-tools-testing-20061214
+   cd kexec-tools-testing-VERSION
 
 5) Configure the package, as follows:
 
_

Patches currently in -mm which might be from horms@verge.net.au are

kdump-documentation-update-for-2620-kexec-tools-update.patch
