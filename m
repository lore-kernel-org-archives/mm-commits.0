Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB0CC49EA5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93EB461220
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhFYBme (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232993AbhFYBme (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:42:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C15C9613B9;
        Fri, 25 Jun 2021 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585213;
        bh=1a5nHMGvY8sYY0zIr/ZMpAooRENxmZ3KzQcKsMR8TPo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GUKJBHY/LuAxPl8SXou0q3HfF54c9nyaPu1JSvf5CBbS5uAaUYTY3Q4eFZ6tf6Cay
         9qLyZmX6LV1l90q+63ylc09dGwYZtio0gogH3I/i5qL7leXZ1ls4PU0Ebx+C6ZoM1H
         tRzVGGr9UcePt2IRK8UlwJrMJqGOZL/2pTdxm+eo=
Date:   Thu, 24 Jun 2021 18:40:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kabel@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 24/24] mailmap: add Marek's other e-mail address
 and identity without diacritics
Message-ID: <20210625014013.qptud_QK_%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
