From: akpm@linux-foundation.org
Subject: + mailmap-fix-krzysztof-kozlowskis-misspelled-name.patch added to -mm tree
Date: Tue, 05 Apr 2016 13:33:46 -0700
Message-ID: <5704212a.cEZDsVdcY2OxDCK9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941AbcDEUdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 16:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzk@kernel.org, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: fix Krzysztof Kozlowski's misspelled name
has been added to the -mm tree.  Its filename is
     mailmap-fix-krzysztof-kozlowskis-misspelled-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mailmap-fix-krzysztof-kozlowskis-misspelled-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mailmap-fix-krzysztof-kozlowskis-misspelled-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: mailmap: fix Krzysztof Kozlowski's misspelled name

Patchwork introduced garbled polish character in commit 1e3012d0fdc5
("crypto: s5p-sss - Use memcpy_toio for iomem annotated memory") so fix
the mail mapping.  Additionally prefer to use kernel.org account for
personal work, instead of my gmail address.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

diff -puN .mailmap~mailmap-fix-krzysztof-kozlowskis-misspelled-name .mailmap
--- a/.mailmap~mailmap-fix-krzysztof-kozlowskis-misspelled-name
+++ a/.mailmap
@@ -79,6 +79,7 @@ Kay Sievers <kay.sievers@vrfy.org>
 Kenneth W Chen <kenneth.w.chen@intel.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
+Krzysztof Kozlowski <krzk@kernel.org> <k.kozlowski.k@gmail.com>
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
 Linas Vepstas <linas@austin.ibm.com>
_

Patches currently in -mm which might be from krzk@kernel.org are

mailmap-fix-krzysztof-kozlowskis-misspelled-name.patch

