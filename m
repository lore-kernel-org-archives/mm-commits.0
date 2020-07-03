From: akpm@linux-foundation.org
Subject: + mailmap-add-entry-for-obsolete-email-address.patch
 added to -mm tree
Date: Thu, 02 Jul 2020 21:58:46 -0700
Message-ID: <20200703045846.16FVHGpu1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgGCE6r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, koct9i@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for obsolete email address
has been added to the -mm tree.  Its filename is
     mailmap-add-entry-for-obsolete-email-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mailmap-add-entry-for-obsolete-email-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mailmap-add-entry-for-obsolete-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mailmap: add entry for obsolete email address

Map old corporate email address @yandex-team.ru to stable private address.

Link: http://lkml.kernel.org/r/159360469186.24918.10108157093572183535.stgit@zurg
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-obsolete-email-address
+++ a/.mailmap
@@ -146,6 +146,7 @@ Kamil Konieczny <k.konieczny@samsung.com
 Kay Sievers <kay.sievers@vrfy.org>
 Kenneth W Chen <kenneth.w.chen@intel.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
+Konstantin Khlebnikov <koct9i@gmail.com> <khlebnikov@yandex-team.ru>
 Koushik <raghavendra.koushik@neterion.com>
 Krzysztof Kozlowski <krzk@kernel.org> <k.kozlowski@samsung.com>
 Krzysztof Kozlowski <krzk@kernel.org> <k.kozlowski.k@gmail.com>
_

Patches currently in -mm which might be from koct9i@gmail.com are

mailmap-add-entry-for-obsolete-email-address.patch
