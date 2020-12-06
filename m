Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98B1C433FE
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 20:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A33F52311B
	for <mm-commits@archiver.kernel.org>; Sun,  6 Dec 2020 20:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLFUwe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Dec 2020 15:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgLFUwd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Dec 2020 15:52:33 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF28C0613D1
        for <mm-commits@vger.kernel.org>; Sun,  6 Dec 2020 12:51:53 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CpzBq0jt4z9sW0;
        Mon,  7 Dec 2020 07:51:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607287909;
        bh=1qh9CYZDyTscbgIWPXre6ddHPXCVIBBCPxk5nJgBx3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HRxj0i1muM+hitZxifxKGQlqWEv8t5MThXlMMfuGzpZ9qb+XjKpYVLuRfuPJYa0II
         QqBkCN8XBRwIttmdFgKcWuJ9gL1Cs87HlHOpvlhHl2gQVbFJGeigftpEMFt3HwM0RS
         /w9z+T9Fh9tWqJg/GrqjkXgvllU3uVzQpnIh1sM5H4ISQ+BoEaudlwAb8W6cTduwg4
         0Lw6kOTvyVy+W7ChC7mZgfNXFAQKXKmD8nzSRnhtGMsX3iWhBhkSjgVATTd7fLQvIX
         atcja3lMYl3C/rac89sgB3yBxc4l8XTqkOg4i6WE5jTCOgbn7350cc+gevKPXcN2Lu
         H0/Vl2w7TSNdg==
Date:   Mon, 7 Dec 2020 07:51:46 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     jonathanh@nvidia.com, liu.hailong6@zte.com.cn,
        m.szyprowski@samsung.com, mm-commits@vger.kernel.org,
        qcai@redhat.com, rppt@kernel.org
Subject: Re: [failures]
 mm-memblock-use-a-more-appropriate-order-calculation-when-free-memblock-pages.patch
 removed from -mm tree
Message-ID: <20201207075146.062cf752@canb.auug.org.au>
In-Reply-To: <20201205005940.ztFbAZFWC%akpm@linux-foundation.org>
References: <20201205005940.ztFbAZFWC%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/c2r.J/4+1r1yIpvpSzXQqMd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/c2r.J/4+1r1yIpvpSzXQqMd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 04 Dec 2020 16:59:40 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm/memblock: use a more appropriate order calculation when =
free memblock pages
> has been removed from the -mm tree.  Its filename was
>      mm-memblock-use-a-more-appropriate-order-calculation-when-free-membl=
ock-pages.patch
>=20
> This patch was dropped because it had testing failures

I have dropped this from linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/c2r.J/4+1r1yIpvpSzXQqMd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/NRGIACgkQAVBC80lX
0GydjAf+OhrRjURX95MxKkbH2aR2yG9Pa0fvDLzqE4K+cgPsZJwHh9K+2x0L7n5Y
tzIobYpaxstI7nc9qdIxTq08HbSZUWjBYxL6lwkS10lXhdvrKCQ2rRtE1yUA7AxC
MweEyupX4mS7ibM/jBv2TB7ZEf7Wqgc197BDT/i66AFspdY8mnMp1v9jgBCd2KHq
YwswhF66PU+RPefnBJh8pmcDYX0CWy2is3wb5rwJndMUM+dtvf51jbABRgbvkg3U
ig2UiWp65agWpP8qGjOakKBHMomt1eZORd74mR2ZQIIKfeNe8YNrpVN8QiDxBEJM
Z1T6DJ2mUB2qQcd2ARzs6ZcLdXN2VA==
=j2H1
-----END PGP SIGNATURE-----

--Sig_/c2r.J/4+1r1yIpvpSzXQqMd--
