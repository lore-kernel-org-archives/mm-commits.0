From: akpm@linux-foundation.org
Subject: + documentation-fixed-documentation-security-00-index.patch added to -mm tree
Date: Tue, 06 Nov 2012 16:38:51 -0800
Message-ID: <20121107003851.77CDB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48350 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2KGAiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 19:38:52 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so120938qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 16:38:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkko.sakkinen@intel.com


The patch titled
     Subject: Documentation: fix Documentation/security/00-INDEX
has been added to the -mm tree.  Its filename is
     documentation-fixed-documentation-security-00-index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Documentation: fix Documentation/security/00-INDEX

keys-ecryptfs.txt was missing from 00-INDEX.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/security/00-INDEX |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/security/00-INDEX~documentation-fixed-documentation-security-00-index Documentation/security/00-INDEX
--- a/Documentation/security/00-INDEX~documentation-fixed-documentation-security-00-index
+++ a/Documentation/security/00-INDEX
@@ -12,6 +12,8 @@ apparmor.txt
 	- documentation on the AppArmor security extension.
 credentials.txt
 	- documentation about credentials in Linux.
+keys-ecryptfs.txt
+	- description of the encryption keys for the ecryptfs filesystem.
 keys-request-key.txt
 	- description of the kernel key request service.
 keys-trusted-encrypted.txt
_

Patches currently in -mm which might be from jarkko.sakkinen@intel.com are

documentation-fixed-documentation-security-00-index.patch

