From: akpm@linux-foundation.org
Subject: - kdump-update-kdump-documentation-as-kexec-tools-resting-has-been-renamed-kexec-tools.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:30:02 -0700
Message-ID: <200807292030.m6TKU25t019754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbYG2UaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kdump: update kdump documentation as kexec-tools-resting has been renamed kexec-tools
has been removed from the -mm tree.  Its filename was
     kdump-update-kdump-documentation-as-kexec-tools-resting-has-been-renamed-kexec-tools.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: update kdump documentation as kexec-tools-resting has been renamed kexec-tools
From: Simon Horman <horms@verge.net.au>

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN Documentation/kdump/kdump.txt~kdump-update-kdump-documentation-as-kexec-tools-resting-has-been-renamed-kexec-tools Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kdump-update-kdump-documentation-as-kexec-tools-resting-has-been-renamed-kexec-tools
+++ a/Documentation/kdump/kdump.txt
@@ -65,26 +65,26 @@ Install kexec-tools
 
 2) Download the kexec-tools user-space package from the following URL:
 
-http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools-testing.tar.gz
+http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools.tar.gz
 
-This is a symlink to the latest version, which at the time of writing is
-20061214, the only release of kexec-tools-testing so far. As other versions
-are released, the older ones will remain available at
-http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
+This is a symlink to the latest version.
 
-Note: Latest kexec-tools-testing git tree is available at
+The latest kexec-tools git tree is available at:
 
-git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools-testing.git
+git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools.git
 or
-http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools-testing.git;a=summary
+http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools.git
+
+More information about kexec-tools can be found at
+http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/README.html
 
 3) Unpack the tarball with the tar command, as follows:
 
-   tar xvpzf kexec-tools-testing.tar.gz
+   tar xvpzf kexec-tools.tar.gz
 
 4) Change to the kexec-tools directory, as follows:
 
-   cd kexec-tools-testing-VERSION
+   cd kexec-tools-VERSION
 
 5) Configure the package, as follows:
 
_

Patches currently in -mm which might be from horms@verge.net.au are


