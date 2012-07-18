From: akpm@linux-foundation.org
Subject: + kexec-update-url-of-kexec-homepage.patch added to -mm tree
Date: Wed, 18 Jul 2012 13:40:30 -0700
Message-ID: <20120718204031.EBD52100079@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51232 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2GRUke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 16:40:34 -0400
Received: by qcqs25 with SMTP id s25so213180qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 13:40:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de


The patch titled
     Subject: kexec: update URL of kexec homepage
has been added to the -mm tree.  Its filename is
     kexec-update-url-of-kexec-homepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: kexec: update URL of kexec homepage

Patches currently in -mm which might be from olaf@aepfle.de are

kexec-update-url-of-kexec-homepage.patch

