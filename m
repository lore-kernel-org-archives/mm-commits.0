Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C51C49EAB
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26E7861C31
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhF0V4u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Jun 2021 17:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhF0V4t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Jun 2021 17:56:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67AEF60FE9;
        Sun, 27 Jun 2021 21:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830865;
        bh=UwIBhXgX69H6sT0vZJIQayr+R2LUo6nY/2RF+BUzPmQ=;
        h=Date:From:To:Subject:From;
        b=2Cls7Y+dH2ENblRB33puDNjLmZojq3Brzp/+QFy7h+3BhMIFWG5kLUXjzd6Xt+6hq
         +BeNl1kwm06wENIKsjDpvzKMpdnsmaZXUJiOjBKvq5C2TPw+DLf2OnLPnHXlZoz91l
         s+ZiWOj0N/qs7xMgpU395roxdFf1/9VPG5lo1TYU=
Date:   Sun, 27 Jun 2021 14:54:25 -0700
From:   akpm@linux-foundation.org
To:     kabel@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 mailmap-add-my-other-e-mail-address-and-identity-without-diacritics.patch
 removed from -mm tree
Message-ID: <20210627215425.NyslCHYld%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add Marek's other e-mail address and identity withou=
t diacritics
has been removed from the -mm tree.  Its filename was
     mailmap-add-my-other-e-mail-address-and-identity-without-diacritics.pa=
tch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Marek Beh=C3=BAn <kabel@kernel.org>
Subject: mailmap: add Marek's other e-mail address and identity without dia=
critics

Some of my commits were sent with identities
  Marek Behun <marek.behun@nic.cz>
  Marek Beh=C3=BAn <marek.behun@nic.cz>
while the correct one is
  Marek Beh=C3=BAn <kabel@kernel.org>

Put this into mailmap so that git shortlog prints all my commits under
one identity.

Link: https://lkml.kernel.org/r/20210616113624.19351-2-kabel@kernel.org
Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-my-other-e-mail-address-and-identity-without-dia=
critics
+++ a/.mailmap
@@ -212,6 +212,8 @@ Manivannan Sadhasivam <mani@kernel.org>
 Manivannan Sadhasivam <mani@kernel.org> <manivannan.sadhasivam@linaro.org>
 Marcin Nowakowski <marcin.nowakowski@mips.com> <marcin.nowakowski@imgtec.c=
om>
 Marc Zyngier <maz@kernel.org> <marc.zyngier@arm.com>
+Marek Beh=C3=BAn <kabel@kernel.org> <marek.behun@nic.cz>
+Marek Beh=C3=BAn <kabel@kernel.org> Marek Behun <marek.behun@nic.cz>
 Mark Brown <broonie@sirena.org.uk>
 Mark Starovoytov <mstarovo@pm.me> <mstarovoitov@marvell.com>
 Mark Yao <markyao0591@gmail.com> <mark.yao@rock-chips.com>
_

Patches currently in -mm which might be from kabel@kernel.org are


