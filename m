Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E2CC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 01:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E77CF61404
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 01:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhEMBVj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 21:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhEMBVj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 May 2021 21:21:39 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2B8C061574
        for <mm-commits@vger.kernel.org>; Wed, 12 May 2021 18:20:29 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FgYkG0SGfz9sWM;
        Thu, 13 May 2021 11:20:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620868824;
        bh=BCPpmQTJdiV/p/4eJ65KrimDr7igczfW63uoIeJdjkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GrpQMZRdxrSeTqqmX7FGN7PgfG43ERQ/x1HTnYbUqWbEcq4rLYNflvXtjjGIC7p05
         zGZjwreN41zWlBd7Dz8PXnuHKmUln9X+y4MOoexVz3oOVRUOM4/4ccpo0ohTkbOXhZ
         ujp52C39mjnzPwFfbVmU8pE4tbMMtxvXsPdSka6UXl2Wywsrn8I67Lt1VKdGsUsKol
         wk3c1AhQBnfaRO9HTrCuwkzvP1RFAwtKI5U6PAK3eegJ4erMASzAqFc75g2DE3w4lA
         5EGsmFaTH4RjmAbuAIbDp1oycjSVTqUQN48WHodJ5NAN4M/CM6cer4EgKeGAcfDaaO
         l+JnqjlxmYtNg==
Date:   Thu, 13 May 2021 11:20:20 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject: Re: +
 mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch added to -mm
 tree
Message-ID: <20210513112020.3cff578f@canb.auug.org.au>
In-Reply-To: <20210513003326.ZvcnI0LXP%akpm@linux-foundation.org>
References: <20210513003326.ZvcnI0LXP%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/swtgIuI/Pv77AbOsY1Q5vMB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/swtgIuI/Pv77AbOsY1Q5vMB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 12 May 2021 17:33:26 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
> has been added to the -mm tree.  Its filename is
>      mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch

Added to linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/swtgIuI/Pv77AbOsY1Q5vMB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCcftQACgkQAVBC80lX
0GxU2gf/REVzEsGBXCcy/1MEqxM5uthjNeVS+Gv5EOYk/cQ/a/In6CDieGaNSfFw
Jb67oNrXEUdniVgEokskoYCGgL+IZ5Kw3XoIWy9tNKpAx5x3iJCRa0DtfoLWQgMO
9qRqGnmOVhGD0ILFRg8i8k00Em2VGSIJ0buXPJ2ty3BHNnglQL9GloSn4sklZsVT
wvoDyO2bhXdDYxzxA7NmxiBUvW/AubT4LQwsonIPSVNe1dgIeCWJB1Yzw5986L+H
OXjvb8I1i3JZNROeE5kwv7p4MjNibIzB7Y0Q7JzHDSTre/GQK2DDPTb4fvc6/bUs
EVztTfW+5Q3ize58MhmUTzi0IOpfdA==
=ptIC
-----END PGP SIGNATURE-----

--Sig_/swtgIuI/Pv77AbOsY1Q5vMB--
