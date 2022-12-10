Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18670C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 02:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiLJCly (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 21:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLJClx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 21:41:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49DE79C85
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 18:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51C94623D6
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 02:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0DAC433D2;
        Sat, 10 Dec 2022 02:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670640111;
        bh=CQqAOGU0rpfF65p8go3NgDLEmSCF2CS8QepWcHCkrs0=;
        h=Date:To:From:Subject:From;
        b=Mt0pck5NiuCJnyzdj5l70ltM/JF+In0qyXeQbx65f12fI6bY6PkelSwZ8Nh6AlTgX
         TLuKx33IbyNEvELWYvSlql4ENw9pnrt9XwXDoCX8Il8VFwCR93eINneIbGd6vuARHA
         9W60t/G3KOWFgXvujvk6HTm4tZFRneRW5t8GMPXk=
Date:   Fri, 09 Dec 2022 18:41:50 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        qyousef@layalina.io, krzysztof.kozlowski@linaro.org,
        colin.i.king@gmail.com, bwidawsk@kernel.org, brauner@kernel.org,
        baolin.wang@linux.alibaba.com, atishp@atishpatra.org,
        arnd@arndb.de, anup@brainfault.org, andersson@kernel.org,
        mazziesaccount@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-matti-vaittinens-email-address.patch removed from -mm tree
Message-Id: <20221210024151.8D0DAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update Matti Vaittinen's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-matti-vaittinens-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


