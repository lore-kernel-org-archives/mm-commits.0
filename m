Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAED9C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 21:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiLAV5w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 16:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiLAV5v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 16:57:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF592B184
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 13:57:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 371F6B81FC9
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 21:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1C4C433C1;
        Thu,  1 Dec 2022 21:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669931866;
        bh=iH62jqps/U2XE+3E1Rtj3dNQoS3eoqSGU9X0MHMIOeg=;
        h=Date:To:From:Subject:From;
        b=i6oND7w5DgQdnWqNPr3k04c5kvKbJQfdjsgDgshyCST7IrzGZ54feEfQuJOYR5whn
         D/0w1oaPFsCiN8c1ISqDshEji3m11IpduMZ9Id1uDBIflA/jI822KycCxGW9xCfJ6s
         +9amQDcleXUn9+xzD4leFnb5sdXZ0EG7V85GAiIE=
Date:   Thu, 01 Dec 2022 13:57:46 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        qyousef@layalina.io, krzysztof.kozlowski@linaro.org,
        colin.i.king@gmail.com, bwidawsk@kernel.org, brauner@kernel.org,
        baolin.wang@linux.alibaba.com, atishp@atishpatra.org,
        arnd@arndb.de, anup@brainfault.org, andersson@kernel.org,
        mazziesaccount@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-matti-vaittinens-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20221201215746.BC1C4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Matti Vaittinen's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-matti-vaittinens-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-matti-vaittinens-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Matti Vaittinen <mazziesaccount@gmail.com>
Subject: mailmap: update Matti Vaittinen's email address
Date: Thu, 1 Dec 2022 18:45:40 +0200

The email backend used by ROHM keeps labeling patches as spam.  This can
result in missing the patches.

Switch my mail address from a company mail to a personal one.

Link: https://lkml.kernel.org/r/8f4498b66fedcbded37b3b87e0c516e659f8f583.1669912977.git.mazziesaccount@gmail.com
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Anup Patel <anup@brainfault.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Atish Patra <atishp@atishpatra.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ben Widawsky <bwidawsk@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-matti-vaittinens-email-address
+++ a/.mailmap
@@ -287,6 +287,7 @@ Matthew Wilcox <willy@infradead.org> <wi
 Matthew Wilcox <willy@infradead.org> <willy@parisc-linux.org>
 Matthias Fuchs <socketcan@esd.eu> <matthias.fuchs@esd.eu>
 Matthieu CASTET <castet.matthieu@free.fr>
+Matti Vaittinen <mazziesaccount@gmail.com> <matti.vaittinen@fi.rohmeurope.com>
 Matt Ranostay <matt.ranostay@konsulko.com> <matt@ranostay.consulting>
 Matt Ranostay <mranostay@gmail.com> Matthew Ranostay <mranostay@embeddedalley.com>
 Matt Ranostay <mranostay@gmail.com> <matt.ranostay@intel.com>
_

Patches currently in -mm which might be from mazziesaccount@gmail.com are

mailmap-update-matti-vaittinens-email-address.patch

