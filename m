Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C806BC43462
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB4A761411
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346913AbhELXdq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 19:33:46 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49735 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346622AbhELXEE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 19:04:04 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FgVgT0Zknz9sWQ;
        Thu, 13 May 2021 09:02:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620860566;
        bh=H9zvpQCbSdyvNGb2VCU2OJm82hYWfgAr26/jc+n3/mo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j7yVu0N+jdr0zgw97BjdbTONSm5rNpToQPswMqUt6MnODiYrRfRM00h9DyWkXIIId
         gmzugAS2Jx6zxcSNSNP/4vJzgbpd8aghflXDulnQF5019QFH/6JgL26XeXHO4PPo/M
         ntE1uWJywdVrm1Zo9FUoW6RtHWr8FAjwM08LCozB5wTNKMwEFO3wMnJSqrukZD4D3l
         p/rmwx4N6nrlYYZ2BsLjIwaBizkace+sUmkEzIYVax2ZpHVjnpk8GYHEP36uzy5ISN
         xndubT8tRXc/MO+kZcOOm7nMOCrSP6tQFM0+oOth/mCNo+/5VJT8csbzA0E7C1aRqk
         J5XQOBvHU9RBw==
Date:   Thu, 13 May 2021 09:02:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     david@redhat.com, mm-commits@vger.kernel.org
Subject: Re: + binfmt-remove-in-tree-usage-of-map_executable-fix.patch added
 to -mm tree
Message-ID: <20210513090244.5ddbfda7@canb.auug.org.au>
In-Reply-To: <20210512212952.NMwm3J6ej%akpm@linux-foundation.org>
References: <20210512212952.NMwm3J6ej%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7zg3McbqNCKzJx9ffxIPFiI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/7zg3McbqNCKzJx9ffxIPFiI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 12 May 2021 14:29:52 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: binfmt-remove-in-tree-usage-of-map_executable-fix
> has been added to the -mm tree.  Its filename is
>      binfmt-remove-in-tree-usage-of-map_executable-fix.patch

Added to linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/7zg3McbqNCKzJx9ffxIPFiI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCcXpQACgkQAVBC80lX
0Gyibgf/XXq8nUleO6mSZT/xTp6uiibTuCYhvGBpQF6ue4IqwLSeCfg6zd5dAqxF
uKsddoaVEyQ+lD+uz6sRrxd6zbPnXeAbuKX7m2LbFF2u+iPaHESeYKPR0pOlDjQI
nVSBY1XKkuU8ALB2uM701tgZuqsVdQg7SDRVnXGx9CzTKSIjOFScB9yhcbf7hHTc
oFbWcLJAeNNRLn+PB1DyvPtIpcp0FuJpIaA1qFd7q96N28pPFGHElm/swMjYjMHq
kMGMoWWQHF1AR3JmQbRN5ML2/M6cWtwqDOAFQq2XoCs6eqTUYEfQgxsnrZWrb7sG
P5usrQOKgh4dZVvmD3orBnNVgnkuEA==
=1ibz
-----END PGP SIGNATURE-----

--Sig_/7zg3McbqNCKzJx9ffxIPFiI--
