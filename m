Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06741C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 08:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76C52229C
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 08:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgLOIKg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 03:10:36 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:52159 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgLOIKe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 03:10:34 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cw9sT6vwlz9sRR;
        Tue, 15 Dec 2020 19:09:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1608019790;
        bh=/esSPJBBY+rJ+eU3zLer5NF+/DA05qG140F8N8wSbNk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ti+kz2iubJyS4zN5XVTkl4p09XAxHFLwwN+llMu2VzL6Spm2NmmGfOwH6+JJlTboQ
         mwX111oJb8t3/L/WDYUF0JtLZiUGnLA10NTjesgZTI3l+ckIkLYWvdS8grvDgv+MOc
         GsZy9k8MpJvwGjqIcDK8nlI9KWRTzpq3GtzsisziIJ7ehwLhu3thJ/Etpj1zjSrDot
         ccGihvkQPDpLZvzhA0iZHnZfXviKDCsYhoXrUTPwtQI7eZDRMLl/o5eW7fgOsvurew
         ponM849gUojvbZ6u/JPrp6m8ErMfjYL6ojUy3uC65mVDTEbc6BGwAIizl/N2yr02IL
         Fy6dMAc4tGXkg==
Date:   Tue, 15 Dec 2020 19:09:48 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     jhubbard@nvidia.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject: Re: + secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch
 added to -mm tree
Message-ID: <20201215190948.5d35a137@canb.auug.org.au>
In-Reply-To: <20201214233054.jj4o_opls%akpm@linux-foundation.org>
References: <20201214233054.jj4o_opls%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KjaI6bHqdZYNW+CThtGS.3U";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/KjaI6bHqdZYNW+CThtGS.3U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 14 Dec 2020 15:30:54 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: secretmem-test-add-basic-selftest-for-memfd_secret2-fix
> has been added to the -mm tree.  Its filename is
>      secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/KjaI6bHqdZYNW+CThtGS.3U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/Yb0wACgkQAVBC80lX
0Gw5vQgAneIOhv1VJGhzxQueb4J4a92O0fOyXyO7aGmNRS2cIIPmSKjxEbK3MVki
7NnoIy9hV/8YVO65vpjTiA3a36iqEwZg/am8qlpFIm/Wh0nBssXdT28M1goT6YBm
Ta6Hj8meqymvDeyHdVq8mGqYVFPmTPmnRAnxY5hjsmxK7RtVpAERfsjbGO1NTVfF
qqijKwJ0UgfeJeIVPwWz+DChnF72MtfGw3xWgOk3tCeVjhsPv4PkZBkex7SGnahm
65zyHDRAOju27X0ptdB5n0nMhBCFx5ez74A35V571id91di1VvtrQpPRZXrpezl+
9z1VUOXwbrrAjQ4AsY7mjSkom+X0Ew==
=VHCT
-----END PGP SIGNATURE-----

--Sig_/KjaI6bHqdZYNW+CThtGS.3U--
