From: akpm@linux-foundation.org
Subject: + maintainers-openbmc-mailing-list-is-moderated.patch added to
 -mm tree
Date: Wed, 02 Aug 2017 14:14:51 -0700
Message-ID: <598240cb.vpoALT2QxXQbakOH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38322 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdHBVOv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 17:14:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, benh@kernel.crashing.org, brendanhiggins@google.com, joel@jms.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: openbmc mailing list is moderated
has been added to the -mm tree.  Its filename is
     maintainers-openbmc-mailing-list-is-moderated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-openbmc-mailing-list-is-moderated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-openbmc-mailing-list-is-moderated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: openbmc mailing list is moderated

The openbmc mailing list is moderated for non-subscribers.

Link: http://lkml.kernel.org/r/8ee80862-dca1-621b-a0cc-30a9fc0cb9fa@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Joel Stanley <joel@jms.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-openbmc-mailing-list-is-moderated MAINTAINERS
--- a/MAINTAINERS~maintainers-openbmc-mailing-list-is-moderated
+++ a/MAINTAINERS
@@ -1161,7 +1161,7 @@ M:	Brendan Higgins <brendanhiggins@googl
 R:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
 R:	Joel Stanley <joel@jms.id.au>
 L:	linux-i2c@vger.kernel.org
-L:	openbmc@lists.ozlabs.org
+L:	openbmc@lists.ozlabs.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/irqchip/irq-aspeed-i2c-ic.c
 F:	drivers/i2c/busses/i2c-aspeed.c
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maintainers-openbmc-mailing-list-is-moderated.patch

