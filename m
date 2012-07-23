From: akpm@linux-foundation.org
Subject: [merged] kexec-update-url-of-kexec-homepage.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:31:12 -0700
Message-ID: <20120723213112.97AD0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:49094 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab2GWVbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:31:13 -0400
Received: by vcqp1 with SMTP id p1so782569vcq.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:31:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: update URL of kexec homepage
has been removed from the -mm tree.  Its filename was
     kexec-update-url-of-kexec-homepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Olaf Hering <olaf@aepfle.de>
Subject: kexec: update URL of kexec homepage

The referenced html file does not exist anymore. Replace the URL with
the current project homepage.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kdump/kdump.txt~kexec-update-url-of-kexec-homepage Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kexec-update-url-of-kexec-homepage
+++ a/Documentation/kdump/kdump.txt
@@ -86,7 +86,7 @@ There is also a gitweb interface availab
 http://www.kernel.org/git/?p=utils/kernel/kexec/kexec-tools.git
 
 More information about kexec-tools can be found at
-http://www.kernel.org/pub/linux/utils/kernel/kexec/README.html
+http://horms.net/projects/kexec/
 
 3) Unpack the tarball with the tar command, as follows:
 
_

Patches currently in -mm which might be from olaf@aepfle.de are

linux-next.patch

