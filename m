Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826D5C6FD1C
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 09:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjCWJSM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 05:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbjCWJSL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 05:18:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D48C1
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 02:18:10 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pfH5E-00032N-Pe; Thu, 23 Mar 2023 10:18:08 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pfH5C-0067Ij-TD; Thu, 23 Mar 2023 10:18:06 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pfH5C-007IMG-6H; Thu, 23 Mar 2023 10:18:06 +0100
Date:   Thu, 23 Mar 2023 10:18:06 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, l.goehrs@pengutronix.de
Subject: Re: [merged mm-hotfixes-stable]
 mailmap-add-entry-for-leonard-gohrs.patch removed from -mm tree
Message-ID: <20230323091806.go4g5g4uluktqvta@pengutronix.de>
References: <20230323013230.82A86C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5ac76rrga263skdw"
Content-Disposition: inline
In-Reply-To: <20230323013230.82A86C433D2@smtp.kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: mm-commits@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


--5ac76rrga263skdw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Andrew,

On Wed, Mar 22, 2023 at 06:32:29PM -0700, Andrew Morton wrote:
>=20
> The quilt patch titled
>      Subject: .mailmap: add entry for Leonard G=F6hrs
> has been removed from the -mm tree.  Its filename was
>      mailmap-add-entry-for-leonard-gohrs.patch
>=20
> This patch was dropped because it was merged into the mm-hotfixes-stable =
branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>=20
> ------------------------------------------------------
> From: Leonard G=F6hrs <l.goehrs@pengutronix.de>
> Subject: .mailmap: add entry for Leonard G=F6hrs
> Date: Tue, 21 Mar 2023 15:55:25 +0100
>=20
> My very first kernel commit:
>=20
>   e4e1d47c7906 ("ALSA: ppc: remove redundant checks in PS3 driver probe")
>=20
> was sent with the umlaut in my last name transcribed (G=F6hrs -> Goehrs).
>=20
> Add a mailmap entry so all my commits use the same name.
>=20
> Link: https://lkml.kernel.org/r/20230321145525.1317230-1-l.goehrs@pengutr=
onix.de
> Signed-off-by: Leonard G=F6hrs <l.goehrs@pengutronix.de>
> Acked-by: Uwe Kleine-Knig <u.kleine-koenig@pengutronix.de>

That commit fixed the =F6 in Leonards commit, but failed to write mine
correctly. Is it already to late to make my name read "Kleine-K=F6nig"?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--5ac76rrga263skdw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmQcGU0ACgkQj4D7WH0S
/k7aEwgAuMGHvWWzRNYdnIJNuLK5NBkg9T4lp43g/oIcxG4Y8GfaOAWtSeIJOP6L
hW42iHIqnt5q9GrIiD69+tj/1sZePMQUc+Qhtmwu3O38Ub9zY6A2Fasy+UK7A/Mk
/fy3PS5raNSzUOM0htyg8qu/UsOGNjr3qsozNRvm80GAKzdAJZ14EsTYcR9+/TBf
HNDIhtFJ/uV9/4ZBOPXdvVa4ahF3gegsuH9DDQND4u0xyjedc7vMxVwKezkSuSqu
wg8WU0boJAVqHqqcV+LAWcpiMhWrbmisFXehuv/E4qW3tZXCqfbJVmRHuHDuXSVS
nEbdnOESWm+3Oo4jIyRlSdeDCN4opg==
=JK4v
-----END PGP SIGNATURE-----

--5ac76rrga263skdw--
