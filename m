Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB19C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 08:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B5E619BC
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 08:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhCaIXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 04:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhCaIWk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Mar 2021 04:22:40 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D60C061574
        for <mm-commits@vger.kernel.org>; Wed, 31 Mar 2021 01:22:37 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F9K7D0C0Pz9sPf;
        Wed, 31 Mar 2021 19:22:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617178953;
        bh=EUkA/3mXkNta9Lkz0MK/N9wGF0f0HEVWahqStAuY8pY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rGke5eCxCZvPUfmEMy/xp+B9xoZrjkpX3liAMUAQEibhJ85fsEPubv8JCUVFI3DcH
         nT9HshP6l0Z+KPQmo99S36po49OS5dclJerofnLeufIEVC4fktkPq1MV8gHv8ei0gR
         uY8LatBQGzRtfzkZoS+ym+s7gulus+CoxavsZJUqS0NbPqaWT+D8/c18kmow298fMO
         bvjVLLPiDapIs2BiVCU8aphZKNmT0KdNQC/ceyUc8qXmHri/qkXe1cC9g4N05s2FKy
         tJQY6YR0CWb96+Ein4WL0qNEQYKI6lYYZnO8dEmiHe/ZMy8qSg1eaECHvFkZxYl0Gr
         uBWl9P/6thhvQ==
Date:   Wed, 31 Mar 2021 19:22:30 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     andreyknvl@google.com, mm-commits@vger.kernel.org,
        slyfox@gentoo.org, vbabka@suse.cz
Subject: Re: + kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch
 added to -mm tree
Message-ID: <20210331192230.30bceceb@canb.auug.org.au>
In-Reply-To: <20210331043528.r1i41QfFj%akpm@linux-foundation.org>
References: <20210331043528.r1i41QfFj%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/h4wZ1hY6dAYQGZEtCLAMb4I";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/h4wZ1hY6dAYQGZEtCLAMb4I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 30 Mar 2021 21:35:28 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm, kasan: fix for "integrate page_alloc init with HW_TAGS"
> has been added to the -mm tree.  Its filename is
>      kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/h4wZ1hY6dAYQGZEtCLAMb4I
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBkMUYACgkQAVBC80lX
0Gw7eAgAgTvG1q4V0M8Rmd0C9ZhP3L9uWrWuxuBBqbYglJZxTMuEaqric8aua8qk
sH6LeTpha7baicPpMI1UlJ2uuHjoma6epGsLns8L3WLUAZEUVym1NsyfwrGaTvZr
xU9zlA50MTyPwK2BdxclmQwTq7J/lIan09y0ksU3qRvxSAwH0XHfXyG0+ssl2xzZ
+z1Wp2p6HEwHmLn5iOkFOTUVwOKPUjHJ1adGOaffFJpJ228Iskil8j1wfh+EQdEK
Ayh5HOVW6i3/lY4S7i3xz7E+oo+BR+5TP+lo7MTxHx4uK4GypEsbOELHJ/eAcWDV
QqEbDhsWIK52j2qG8rDVlbzOCjKsrw==
=Sd6w
-----END PGP SIGNATURE-----

--Sig_/h4wZ1hY6dAYQGZEtCLAMb4I--
