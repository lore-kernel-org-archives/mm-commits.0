Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163F2C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jan 2022 01:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346450AbiAKBzK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jan 2022 20:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344455AbiAKBzK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jan 2022 20:55:10 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156FEC06173F
        for <mm-commits@vger.kernel.org>; Mon, 10 Jan 2022 17:55:10 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JXv041xjGz4y4c;
        Tue, 11 Jan 2022 12:55:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641866104;
        bh=n58kCEU5t91VvD3XhAFGRFoESne3mrSggnP4BsLvRYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fDGEygPRtkBvn/cKgp6e4Un09q3TyargwDEN1cR9mBY/3fDLpUZeEMApxrZPZnFeU
         FnOJq9yAFCRcnggQwhkrkk3C5ZI4tk9nzwJUsAPguRYHaa7dG3fn1aoXNoPOFJHmMt
         juwcSbsPzOe6aeAa1bg25rDdvCTJsrPAIpnHBOftijzvFRMkCVaJP+gwurnOccTvTm
         MoaFxfmd7mwFjYwpzII5cHjPbTXqJcYMkZrbPsWDC3Wz25IDi4auHqjB9mrhBVrBES
         ZmEvDvG6bzXxioKt8Xl66EtDwmUux+i3qkTkTsJN1urEy2QBr4E5EJGJeyf/EsnWni
         juVLeyIESj/vg==
Date:   Tue, 11 Jan 2022 12:54:57 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     gpiccoli@igalia.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: + sysctl-documentation-fix-table-format-warning.patch added to
 -mm tree
Message-ID: <20220111125438.18b365e6@elm.ozlabs.ibm.com>
In-Reply-To: <20220110203048.uyNlNwDRH%akpm@linux-foundation.org>
References: <20220110203048.uyNlNwDRH%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LirSwGX+xy2Uom3VlQ98Zv2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/LirSwGX+xy2Uom3VlQ98Zv2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 10 Jan 2022 12:30:48 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: sysctl: documentation: fix table format warning
> has been added to the -mm tree.  Its filename is
>      sysctl-documentation-fix-table-format-warning.patch
>=20
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/sysctl-documentation-fix-ta=
ble-format-warning.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-documentation-fix-ta=
ble-format-warning.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/LirSwGX+xy2Uom3VlQ98Zv2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHc43EACgkQAVBC80lX
0GyW6wf+P9NK5uXTwXyGrlfMtV1HEhNWgcdVafN8gb/CwwAckVPGiVxPyt6wP1d5
U5TB+xtlK2rHSCRwyMgF1jjCorqjCkcqCeGrWFGa1sbpnLuqlhfL+C2FLpho2UhK
FIZfGW1+jhX4vCva9NOzAiu0+ii/6pW/MFF+LYZzOnZ0SyTy9bf/YDUX5ZgG9Baz
/4EHnemLP9M9+3m6Z4t3MviL34lZSVLDm/19zdE9DCO66Jng+l+aSkWF8IbQiI09
5XDVqlh7Z6CT8Kpehd0GfUguARZPZ9ZUWCbKBdLO7NwYkIw387TGjX7PN59tjCBc
Sh/G6wgrEElJf5dGxcDViCVFewAmgw==
=3Lyt
-----END PGP SIGNATURE-----

--Sig_/LirSwGX+xy2Uom3VlQ98Zv2--
